import { ethers } from "ethers";
import Counter from "../artifacts/contracts/Counter.sol/Counter.json";

async function hasSigners(): Promise<boolean> {
  //@ts-ignore
  const metamask = window.ethereum;
  const signers = await (metamask.request({
    method: "eth_accounts",
  }) as Promise<string[]>);
  return signers.length > 0;
}

async function requestAccess(): Promise<boolean> {
  //@ts-ignore
  const result = (await window.ethereum.request({
    method: "eth_requestAccounts",
  })) as string[];
  return result && result.length > 0;
}

async function getContract() {
  if (!(await hasSigners()) && !(await requestAccess())) {
    console.log("You are in trouble, no one wants to play");
  }

  // @ts-ignore
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const contract = new ethers.Contract(
    process.env.CONTRACT_ADDRESS,
    // [
    //   "function count() public",
    //   "function getCounter() public view returns (uint32)",
    // ], // abi
    Counter.abi,
    provider.getSigner()
  );

  console.log("We have done it, time to call");

  const el = document.createElement("div");
  async function setCounter(count) {
    el.innerHTML = count || (await contract.getCounter());
  }
  // setCounter();
  const button = document.createElement("button");
  button.innerText = "Increment";
  button.onclick = async function () {
    // const tx = await contract.count();
    await contract.count();
    // await tx.wait();
    // setCounter();
  };

  contract.on(contract.filters.CounterInc(), function (count) {
    setCounter(count);
  });

  document.body.appendChild(el);
  document.body.appendChild(button);

  // document.body.innerHTML = await contract.hello();
  // console.log(await contract.hello());
}

getContract();
