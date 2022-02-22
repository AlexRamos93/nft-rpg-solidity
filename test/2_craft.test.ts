import { expect } from "chai";
import { BigNumber } from "ethers";
import { Result } from "ethers/lib/utils";
import { ethers } from "hardhat";
import {
  Equipment,
  Equipment__factory,
  Craft,
  Craft__factory,
  AmorCodex,
  AmorCodex__factory,
  WeaponCodex,
  WeaponCodex__factory,
  Hero,
  Hero__factory,
  HelmetCodex,
  HelmetCodex__factory,
  Stats,
  Stats__factory,
} from "../typechain";

let HeroContract: Hero__factory;
let heroInstance: Hero;
let StatsContract: Stats__factory;
let statsInstance: Stats;

let CraftContract: Craft__factory;
let craftInstance: Craft;
let ArmorCodexContract: AmorCodex__factory;
let aCodexInstance: AmorCodex;
let EquipmentContract: Equipment__factory;
let equipInstance: Equipment;
let WeaponCodexContract: WeaponCodex__factory;
let wCodexInstance: WeaponCodex;
let hCodexInstance: HelmetCodex;
let HelmetCodexContract: HelmetCodex__factory;

let heroId = 1;

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
    // console.log(formatArmor(item));
  });
});

describe("Equipment Contract", async () => {
  it("Shouldnt allow not a hero owner equip a item", async () => {});
  it("Shouldnt allow not a item owner equip a item", async () => {});
  it("Should revert if a invalid equipment type was passed", async () => {});
  it("Should revert if tries to unequip a empty equipment", async () => {});
  it("Shouldnt allow equip a two handed sword with another arm already equipped", async () => {});
  it("Should correctly equip a armor", async () => {
    await heroInstance.summon(7);
    const tx = await equipInstance.equip(heroId, 1, 1);
    await tx.wait();
    const armor = await equipInstance.getHeroArmor(1);
    const parsedArmor = formatArmor(armor);
    expect(parsedArmor.name).to.be.eq("Dragon scale mail");
    expect(parsedArmor.id).to.be.eq(1);
    expect(parsedArmor.defense).to.be.eq(16);
  });
});

// HELPER FUNCTIONS

const setupHeroStats = async () => {
  HeroContract = await ethers.getContractFactory("Hero");
  StatsContract = await ethers.getContractFactory("Stats");
  heroInstance = await HeroContract.deploy();
  statsInstance = await StatsContract.deploy(heroInstance.address);
  await heroInstance.deployed();
  await statsInstance.deployed();
};

const setup = async () => {
  await setupHeroStats();
  CraftContract = await ethers.getContractFactory("Craft");
  ArmorCodexContract = await ethers.getContractFactory("AmorCodex");
  EquipmentContract = await ethers.getContractFactory("Equipment");
  WeaponCodexContract = await ethers.getContractFactory("WeaponCodex");
  HelmetCodexContract = await ethers.getContractFactory("HelmetCodex");
  craftInstance = await CraftContract.deploy();
  aCodexInstance = await ArmorCodexContract.deploy();
  wCodexInstance = await WeaponCodexContract.deploy();
  hCodexInstance = await HelmetCodexContract.deploy();
  equipInstance = await EquipmentContract.deploy(
    craftInstance.address,
    heroInstance.address,
    wCodexInstance.address,
    aCodexInstance.address,
    hCodexInstance.address
  );
  await heroInstance.deployed();
  await wCodexInstance.deployed();
  await craftInstance.deployed();
  await aCodexInstance.deployed();
  await hCodexInstance.deployed();
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
