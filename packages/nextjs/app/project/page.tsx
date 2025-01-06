"use client";

import { useState } from "react";
import type { NextPage } from "next";
import { useAccount } from "wagmi";
// import { globalData } from "~~/components/GlobalVariable";
import { globalData } from "~~/components/GlobalVariable";
import { InputBase } from "~~/components/scaffold-eth";
import { useScaffoldReadContract, useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

const Project: NextPage = () => {
  const { address: connectedAddress } = useAccount();

  const { data: project } = useScaffoldReadContract({
    contractName: "Project",
    functionName: "getProjects",
    args: [connectedAddress],
  });

  // Contract Write Action
  const { writeContractAsync: writeSplitCoinAsync } = useScaffoldWriteContract("Project");

  const [projectDesc, setDescription] = useState("");

  const [projectChosen, setProjectChosen] = useState("default");

  if (projectChosen != "default") {
    globalData.projectChosen = projectChosen;
  }

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
          <span className="block text-4xl font-bold">Project: {handleOption(globalData.projectChosen)}</span>
        </h1>
        <div className="pt-3">
          <p className="text-lg mt-0 mb-1 font-semibold">Select a project:</p>
        </div>
        <div className="pt-3 flex border-2 border-base-300 bg-base-200 rounded-full text-accent w-64">
          <select
            className="input input-ghost focus-within:border-transparent focus:outline-none focus:bg-transparent focus:text-gray-400 h-[2.2rem] min-h-[2.2rem] px-4 border w-full font-medium placeholder:text-accent/50 text-gray-400"
            value={globalData.projectChosen}
            onChange={e => setProjectChosen(e.target.value)}
          >
            <option key="" value=""></option>
            {project
              ? project.map(item =>
                  item != "" ? (
                    <option key={item} value={item}>
                      {item}
                    </option>
                  ) : (
                    false
                  ),
                )
              : false}
          </select>
        </div>
        <div className="pt-10">
          <p className="text-lg mt-0 mb-1 font-semibold">Create a new project:</p>
        </div>
        <div className="w-64 pl-2 pt-3">
          <InputBase value={projectDesc} onChange={e => setDescription(e)} />
        </div>
        <div className="pt-3">
          <button
            className="btn btn-primary uppercase"
            onClick={async () => {
              try {
                await writeSplitCoinAsync({
                  functionName: "newProject",
                  args: [projectDesc],
                });
              } catch (err) {
                console.error("Error calling payInsuranceFee function", err);
              }
              setDescription("");
            }}
          >
            💾 Save
          </button>
        </div>
      </div>
    </>
  );
};

export default Project;
