import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { BigNumber } from "ethers";
import { ethers } from "hardhat";
import {
  Material,
  MaterialCodex,
  MaterialCodex__factory,
  Material__factory,
} from "../typechain";

let MaterialContract: Material__factory;
let materialInstance: Material;
let MCodexContract: MaterialCodex__factory;
let mCodexInstance: MaterialCodex;

let addresses: SignerWithAddress[];

describe("Material Contract", async () => {
  before(async () => setup());
  it("Mint successfully 1 dragon scale and 2 dragon claw", async () => {
    const [addr1, addr2] = addresses;
    await materialInstance.mint(addr1.address, 1, 1);
    await materialInstance.mint(addr2.address, 2, 2);
    const balanceOne = await materialInstance.getBalanceOf(1);
    const balanceTwo = await materialInstance.connect(addr2).getBalanceOf(2);
    expect(NormalNumber(balanceOne)).to.be.eq(1);
    expect(NormalNumber(balanceTwo)).to.be.eq(2);
  });
  it("Burn successfully 1 dragon claw", async () => {
    const [_, addr2] = addresses;
    await materialInstance.connect(addr2).spend(addr2.address, [2], [1]);
    const balance = await materialInstance.connect(addr2).getBalanceOf(2);
    expect(NormalNumber(balance)).to.be.eq(1);
  });
  it("Transfer successfully 1 dragon scale", async () => {
    let balanceOne = await materialInstance.getBalanceOf(1);
    expect(NormalNumber(balanceOne)).to.be.eq(1);
    const [_, addr2] = addresses;
    await materialInstance.transfer(addr2.address, [1], [1]);
    balanceOne = await materialInstance.getBalanceOf(1);
    const balanceTwo = await materialInstance.connect(addr2).getBalanceOf(1);
    expect(NormalNumber(balanceOne)).to.be.eq(0);
    expect(NormalNumber(balanceTwo)).to.be.eq(1);
  });
  it("Burn a erc1115 with not enough balance", async () => {
    const [addr1] = addresses;
    await expect(
      materialInstance.spend(addr1.address, [1], [1])
    ).to.be.revertedWith("ERC1155: burn amount exceeds balance");
  });
  it("Shouldnt allow not owner mint a material", async () => {
    const [_, addr2] = addresses;
    await expect(
      materialInstance.connect(addr2).mint(addr2.address, 2, 100)
    ).to.be.revertedWith("Ownable: caller is not the owner");
  });
});

const setup = async () => {
  MaterialContract = await ethers.getContractFactory("Material");
  MCodexContract = await ethers.getContractFactory("MaterialCodex");
  materialInstance = await MaterialContract.deploy();
  mCodexInstance = await MCodexContract.deploy();
  await materialInstance.deployed();
  await mCodexInstance.deployed();
  addresses = await ethers.getSigners();
};

const NormalNumber = (bigNumber: BigNumber) => {
  const etherNumber = ethers.utils.formatEther(bigNumber);
  return Math.round(parseFloat(etherNumber) * 10 ** 18);
};
