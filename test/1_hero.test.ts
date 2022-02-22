import { expect } from "chai";
import { BigNumber, ContractReceipt, ContractTransaction } from "ethers";
import { Result } from "ethers/lib/utils";
import { ethers } from "hardhat";
import { Hero, Hero__factory, Stats, Stats__factory } from "../typechain";

type HeroType = [BigNumber, BigNumber, BigNumber] & {
  level: BigNumber;
  class: BigNumber;
  experience: BigNumber;
};

type StatsType = [
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
  strength: BigNumber;
  vitality: BigNumber;
  dexterity: BigNumber;
  intelligence: BigNumber;
  health: BigNumber;
  defense: BigNumber;
  meleeAttack: BigNumber;
  magicAttack: BigNumber;
  hitRate: BigNumber;
};

let HeroContract: Hero__factory;
let heroInstance: Hero;
let StatsContract: Stats__factory;
let statsInstance: Stats;

let heroId: number;

describe("Hero Contract", async () => {
  before(async () => setup());
  it("Should Hero and Stats contracts address setted correctly", async () => {
    const statsAddr = statsInstance.address;
    const heroAddr = heroInstance.address;
    expect(await statsInstance.heroAddr()).to.be.eq(heroAddr);
    expect(await heroInstance.statsAddr()).to.be.eq(statsAddr);
  });
  it("Should mint a hero with class Druid", async () => {
    const tx = await heroInstance.summon(7);
    const args = await getFromEvent(tx, "Summoned");
    heroId = getFromArgs(args ?? [], "heroId");
    const myHero = await heroInstance.getHero(heroId);
    const parsedHero = formatHero(myHero);
    const classTx = await heroInstance.classes(parsedHero.class);
    expect(parsedHero.level).to.be.eq(1);
    expect(parsedHero.class).to.be.eq(7);
    expect(parsedHero.experience).to.be.eq(0);
    expect(classTx).to.be.eq("Druid");
  });
  it("Should failed when trying to level up", async () => {
    await expect(heroInstance.levelUp(heroId)).to.be.revertedWith(
      "Insufficient experience"
    );
  });
  it("Should level up the hero", async () => {
    await heroInstance.setXp(300, heroId);
    await heroInstance.levelUp(heroId);
    const myHero = await heroInstance.getHero(heroId);
    const parsedHero = formatHero(myHero);
    expect(parsedHero.level).to.be.eq(2);
    expect(parsedHero.experience).to.be.eq(50);
  });
  it("Should return the correct next level xp required for level 2", async () => {
    const xp = await heroInstance.xpRequired(2);
    expect(xp).to.be.eq(500);
  });
});

describe("Stats Contract", async () => {
  it("Should successfully created hero stats", async () => {
    const heroStats = await statsInstance.getHeroStats(heroId);
    const parsedStats = formatStats(heroStats);
    expect(parsedStats.strength).to.be.eq(1);
    expect(parsedStats.vitality).to.be.eq(10);
    expect(parsedStats.dexterity).to.be.eq(9);
    expect(parsedStats.intelligence).to.be.eq(10);
    expect(parsedStats.health).to.be.eq(11);
    expect(parsedStats.defense).to.be.eq(5);
    expect(parsedStats.meleeAttack).to.be.eq(2);
    expect(parsedStats.magicAttack).to.be.eq(11);
    expect(parsedStats.hitRate).to.be.eq(5);
  });
  it("Should has 5 points to spend after leveled up", async () => {
    const points = await statsInstance.getHeroPointsToSpend(heroId);
    expect(NormalNumber(points)).to.be.eq(5);
  });
  it("Should not authorize a not owner increase a stat of a hero", async () => {
    const [_, addr1] = await ethers.getSigners();
    await expect(
      statsInstance.connect(addr1).increaseVitality(heroId, 5)
    ).to.be.revertedWith("Not owner");
  });
  it("Should increase the hero intelligence and magic attack", async () => {
    const tx = await statsInstance.increaseIntelligence(heroId, 5);
    const args = await getFromEvent(tx, "Leveled");
    expect(getFromArgs(args ?? [], "intelligence")).to.be.eq(15);
    expect(getFromArgs(args ?? [], "magicAttack")).to.be.eq(16);
  });
  it("Should not allow a hero increase a stat if it hasnt points to spend", async () => {
    await expect(statsInstance.increaseDexterity(heroId, 2)).to.be.revertedWith(
      "Not enough points"
    );
  });
  it("Should not allow levelUp if the call is not comming from hero contract", async () => {
    await expect(statsInstance.levelUp(heroId)).to.be.revertedWith(
      "Not authorized"
    );
  });
});

// HELPER FUNCTIONS

const setup = async () => {
  HeroContract = await ethers.getContractFactory("Hero");
  StatsContract = await ethers.getContractFactory("Stats");
  heroInstance = await HeroContract.deploy();
  statsInstance = await StatsContract.deploy(heroInstance.address);
  await heroInstance.deployed();
  await statsInstance.deployed();
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

const formatHero = (hero: HeroType) => {
  return {
    level: NormalNumber(hero["level"]),
    class: NormalNumber(hero["class"]),
    experience: NormalNumber(hero["experience"]),
  };
};

const formatStats = (stats: StatsType) => ({
  strength: NormalNumber(stats["strength"]),
  vitality: NormalNumber(stats["vitality"]),
  dexterity: NormalNumber(stats["dexterity"]),
  intelligence: NormalNumber(stats["intelligence"]),
  health: NormalNumber(stats["health"]),
  defense: NormalNumber(stats["defense"]),
  meleeAttack: NormalNumber(stats["meleeAttack"]),
  magicAttack: NormalNumber(stats["magicAttack"]),
  hitRate: NormalNumber(stats["hitRate"]),
});
