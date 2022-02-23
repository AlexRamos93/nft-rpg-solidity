import { expect } from "chai";
import { BigNumber, ContractTransaction } from "ethers";
import { Result } from "ethers/lib/utils";
import { ethers } from "hardhat";
import {
  Craft,
  Craft__factory,
  AmorCodex,
  AmorCodex__factory,
  Coin,
  Coin__factory,
  Material,
  Material__factory,
} from "../typechain";

let CraftContract: Craft__factory;
let craftInstance: Craft;
let ArmorCodexContract: AmorCodex__factory;
let aCodexInstance: AmorCodex;
let CoinContract: Coin__factory;
let coinInstance: Coin;
let MaterialContract: Material__factory;
let mInstance: Material;

type ArmorType = [
  BigNumber,
  string,
  string,
  BigNumber,
  BigNumber,
  BigNumber,
  BigNumber,
  BigNumber,
  BigNumber,
  BigNumber,
  BigNumber,
  BigNumber,
  BigNumber
] & {
  id: BigNumber;
  name: string;
  description: string;
  defense: BigNumber;
  strModifier: BigNumber;
  vitModifier: BigNumber;
  dexModifier: BigNumber;
  intModifier: BigNumber;
  healthModifier: BigNumber;
  defenseModifier: BigNumber;
  atkModifier: BigNumber;
  mAtkModifier: BigNumber;
  hitModifier: BigNumber;
};

type ItemType = [string, BigNumber] & {
  owner: string;
  codexId: BigNumber;
};

describe("Craft Contract", async () => {
  before(async () => setup());
  it("Should craft DSM", async () => {
    const [player] = await ethers.getSigners();
    await mInstance.mint(player.address, 1, 500);
    await mInstance.mint(player.address, 2, 50);
    await mInstance.mint(player.address, 3, 500);
    await coinInstance.approve(craftInstance.address, 15000);
    await mInstance.setApprovalForAll(craftInstance.address, true);
    const tx = await craftInstance.craft(player.address, 1, [1, 2, 3]);
    const args = await getFromEvent(tx, "Crafted");
    const itemId = getFromArgs(args ?? [], "itemId");
    const item = formatItem(await craftInstance.getItemById(itemId));
    const balanceDragonScale = NormalNumber(
      await mInstance.balanceOf(player.address, 1)
    );
    const balanceDragonClaw = NormalNumber(
      await mInstance.balanceOf(player.address, 2)
    );
    const balanceDragonLeather = NormalNumber(
      await mInstance.balanceOf(player.address, 3)
    );
    expect(item.owner).to.be.eq(player.address);
    expect(item.codexId).to.be.eq(1);
    expect(balanceDragonScale).to.be.eq(0);
    expect(balanceDragonClaw).to.be.eq(0);
    expect(balanceDragonLeather).to.be.eq(0);
  });
  it("Shouldnt craft a item if at least one of the materials is not enough", async () => {
    const [player] = await ethers.getSigners();
    await mInstance.mint(player.address, 1, 500);
    await mInstance.mint(player.address, 2, 10);
    await mInstance.mint(player.address, 3, 500);
    await coinInstance.approve(craftInstance.address, 15000);
    await mInstance.setApprovalForAll(craftInstance.address, true);
    await expect(
      craftInstance.craft(player.address, 1, [1, 2, 3])
    ).to.be.revertedWith("Not enough material");
    const balanceDragonScale = NormalNumber(
      await mInstance.balanceOf(player.address, 1)
    );
    const balanceDragonClaw = NormalNumber(
      await mInstance.balanceOf(player.address, 2)
    );
    const balanceDragonLeather = NormalNumber(
      await mInstance.balanceOf(player.address, 3)
    );
    expect(balanceDragonScale).to.be.eq(500);
    expect(balanceDragonClaw).to.be.eq(10);
    expect(balanceDragonLeather).to.be.eq(500);
  });
});

// HELPER FUNCTIONS

const setup = async () => {
  CraftContract = await ethers.getContractFactory("Craft");
  ArmorCodexContract = await ethers.getContractFactory("AmorCodex");
  CoinContract = await ethers.getContractFactory("Coin");
  MaterialContract = await ethers.getContractFactory("Material");
  aCodexInstance = await ArmorCodexContract.deploy();
  coinInstance = await CoinContract.deploy();
  mInstance = await MaterialContract.deploy();
  craftInstance = await CraftContract.deploy(
    aCodexInstance.address,
    mInstance.address,
    coinInstance.address
  );
  await craftInstance.deployed();
  await aCodexInstance.deployed();
  await coinInstance.deployed();
  await mInstance.deployed();
};

const getFromEvent = async (tx: ContractTransaction, eventName: string) => {
  const cr = await tx.wait();
  const event = cr.events?.find((e) => e.event === eventName);
  return event?.args;
};

const getFromArgs = (args: Result, argName: string) =>
  NormalNumber(args[argName]);

const NormalNumber = (bigNumber: BigNumber) => {
  const etherNumber = ethers.utils.formatEther(bigNumber);
  return Math.round(parseFloat(etherNumber) * 10 ** 18);
};

const formatItem = (item: ItemType) => ({
  owner: item["owner"],
  codexId: item["codexId"],
});

const formatArmor = (armor: ArmorType) => ({
  id: NormalNumber(armor["id"]),
  name: armor["name"],
  description: armor["description"],
  defense: NormalNumber(armor["defense"]),
  strModifier: NormalNumber(armor["strModifier"]),
  vitModifier: NormalNumber(armor["vitModifier"]),
  dexModifier: NormalNumber(armor["dexModifier"]),
  intModifier: NormalNumber(armor["intModifier"]),
  healthModifier: NormalNumber(armor["healthModifier"]),
  defenseModifier: NormalNumber(armor["defenseModifier"]),
  atkModifier: NormalNumber(armor["atkModifier"]),
  mAtkModifier: NormalNumber(armor["mAtkModifier"]),
  hitModifier: NormalNumber(armor["hitModifier"]),
});
