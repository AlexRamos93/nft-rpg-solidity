import { expect } from "chai";
import { BigNumber } from "ethers";
import { Result } from "ethers/lib/utils";
import { ethers } from "hardhat";
import {
  Craft,
  Craft__factory,
  AmorCodex,
  AmorCodex__factory,
} from "../typechain";

let CraftContract: Craft__factory;
let craftInstance: Craft;
let ArmorCodexContract: AmorCodex__factory;
let aCodexInstance: AmorCodex;

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

describe("Craft Contract", async () => {
  before(async () => setup());
  it("Should craft DSM", async () => {
    const [player] = await ethers.getSigners();
    const tx = await craftInstance.dungeonCraft(player.address, 1);
    await tx.wait();
    const result = await craftInstance.getItemById(1);
    const codexId = getFromArgs(result, "codexId");
    const item = await aCodexInstance.getArmorById(codexId);
    console.log(formatArmor(item));
  });
});

// HELPER FUNCTIONS

const setup = async () => {
  CraftContract = await ethers.getContractFactory("Craft");
  ArmorCodexContract = await ethers.getContractFactory("AmorCodex");
  craftInstance = await CraftContract.deploy();
  aCodexInstance = await ArmorCodexContract.deploy();
  await craftInstance.deployed();
  await aCodexInstance.deployed();
};

const getFromArgs = (args: Result, argName: string) =>
  NormalNumber(args[argName]);

const NormalNumber = (bigNumber: BigNumber) => {
  const etherNumber = ethers.utils.formatEther(bigNumber);
  return Math.round(parseFloat(etherNumber) * 10 ** 18);
};

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
