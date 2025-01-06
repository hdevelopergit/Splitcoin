"use client";

import { useState } from "react";
import type { NextPage } from "next";
import { formatEther, parseEther } from "viem";
import { useAccount } from "wagmi";
import { globalData } from "~~/components/GlobalVariable";
import { Address, AddressInput, EtherInput } from "~~/components/scaffold-eth";
import { InputBase } from "~~/components/scaffold-eth";
import { useScaffoldReadContract, useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

const Expenses: NextPage = () => {
  const { address: connectedAddress } = useAccount();

  // Contract Write Action
  const { writeContractAsync: writeProjectAsync } = useScaffoldWriteContract("Project");

  const [description, setDescription] = useState("");
  const [price, setPrice] = useState("");
  const [address, setAddress] = useState("");

  let i = BigInt(0);
  let disableButton = false;
  let selectedProject = false;

  if (globalData.projectChosen !== "") {
    const index = globalData.projectChosen.indexOf("-") - 1;
    i = BigInt(globalData.projectChosen.slice(0, index));
    selectedProject = true;
  } else disableButton = true;

  const { data: participant } = useScaffoldReadContract({
    contractName: "Project",
    functionName: "getAddress",
    args: [selectedProject, i],
  });

  const { data: expenses } = useScaffoldReadContract({
    contractName: "Project",
    functionName: "getExpenses",
    args: [selectedProject, i],
  });

  function handleOption(item: string) {
    const index = item.indexOf("-") + 2;
    console.log("index: ", index);
    return item.slice(index);
    // item
  }

  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-10">
        <h1 className="text-center">
          <span className="block text-4xl font-bold">Enter expenses: {handleOption(globalData.projectChosen)}</span>
        </h1>
        <div className="flex flex-row mx-auto mt-5">
          <div className="w-48 pl-2">
            <InputBase value={description} onChange={e => setDescription(e)} />
          </div>
          <div className="w-48 pl-2">
            <EtherInput value={price} onChange={e => setPrice(e)} />
          </div>
        </div>
        <div className="pt-3">
          <button
            className="btn btn-primary uppercase"
            onClick={async () => {
              try {
                await writeProjectAsync({
                  functionName: "saveExpenses",
                  args: [description, parseEther(price), i, connectedAddress],
                });
              } catch (err) {
                console.error("Error calling saveExpenses function", err);
              }
              setDescription("");
              setPrice("");
            }}
            disabled={disableButton}
          >
            💾 Save
          </button>
        </div>
        <div className="pt-10">
          <table className="table table-zebra w-full">
            <thead>
              <tr>
                <th className="bg-primary text-lg">Address </th>
                <th className="bg-primary text-lg">Description</th>
                <th className="bg-primary text-lg">Value</th>
              </tr>
            </thead>
            <tbody>
              {expenses != undefined ? (
                expenses.map(item => (
                  <tr key={item.expenseDesc}>
                    {/* <td className="text-left text-lg">{Address({ address: item.expender })}</td> */}
                    <td className="text-left text-lg">
                      <Address address={item.expender} />
                    </td>
                    <td className="text-left text-lg">{item.expenseDesc}</td>
                    <td className="text-right text-lg">{(+formatEther(item.value)).toFixed(4)}</td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td>No data</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
        <h1 className="text-center pt-10">
          <span className="block text-4xl font-bold">Enter participants</span>
        </h1>
        <div className="flex flex-row mx-auto mt-5 w-96">
          <div className="w-96 pl-2">
            <AddressInput value={address} onChange={e => setAddress(e)} />
          </div>
        </div>
        <div className="pt-3">
          <button
            className="btn btn-primary uppercase"
            onClick={async () => {
              try {
                await writeProjectAsync({
                  functionName: "saveAddress",
                  args: [address, i],
                });
              } catch (err) {
                console.error("Error calling saveAddress function", err);
              }
              setAddress("");
            }}
            disabled={disableButton}
          >
            💾 Save
          </button>
        </div>
        <div className="pt-10">
          <table className="table table-zebra w-full">
            <thead>
              <tr>
                <th className="bg-primary text-lg">Address </th>
              </tr>
            </thead>
            <tbody>
              {participant != undefined ? (
                participant.map(address => (
                  <tr key={address}>
                    <td className="text-left text-lg">
                      <Address address={address} />
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td>No data</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
};

export default Expenses;
