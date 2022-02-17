import { expect } from "chai";
import { BigNumber, ContractReceipt, ContractTransaction } from "ethers";
import { Result } from "ethers/lib/utils";
import { ethers } from "hardhat";
import { Hero, Hero__factory } from "../typechain";

type HeroType = [BigNumber, BigNumber, BigNumber] & {
  level: BigNumber;
  class: BigNumber;
  experience: BigNumber;
};

let HeroContract: Hero__factory;
let heroInstance: Hero;

let heroId: number;

describe("Hero NFT", async () => {
  before(async () => setup());
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
      "Insuficient experience"
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

// HELPER FUNCTIONS

const setup = async () => {
  HeroContract = await ethers.getContractFactory("Hero");
  heroInstance = await HeroContract.deploy();
  await heroInstance.deployed();
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
