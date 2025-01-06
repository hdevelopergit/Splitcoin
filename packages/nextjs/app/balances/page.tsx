"use client";

import type { NextPage } from "next";
import { formatEther } from "viem";
import { useAccount } from "wagmi";
import { globalData } from "~~/components/GlobalVariable";
import { Address } from "~~/components/scaffold-eth";
import { useScaffoldReadContract, useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

const Balances: NextPage = () => {
  const { writeContractAsync: writeProjectAsync } = useScaffoldWriteContract("Project");

  let i = BigInt(0);
  let disableButton = false;
  let selectedProject = false;

  if (globalData.projectChosen !== "") {
    const index = globalData.projectChosen.indexOf("-") - 1;
    i = BigInt(globalData.projectChosen.slice(0, index));
    selectedProject = true;
  } else disableButton = true;

  const { data: transfer } = useScaffoldReadContract({
    contractName: "Project",
    functionName: "getTransfers",
    args: [selectedProject, i],
  });

  const { address: connectedAddress } = useAccount();
  //formatEther(transfer.value)
  const formatValue = (_transferValue: bigint) => {
    let res = formatEther(_transferValue);
    res = (+res).toFixed(4);
    return res;
  };

  // const [disableButton, setDisableButton] = useState(false);

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
          <span className="block text-4xl font-bold">Balances: {handleOption(globalData.projectChosen)}</span>
        </h1>
        <div className="pt-10">
          <button
            className="btn btn-primary uppercase"
            onClick={async () => {
              try {
                await writeProjectAsync({
                  functionName: "calculateTransfers",
                  args: [i],
                });
              } catch (err) {
                console.error("Error calling calculateTransfers function", err);
              }
              // setDisableButton(true);
            }}
            disabled={disableButton}
          >
            Calculate transfers
          </button>
        </div>
        <div className="pt-10">
          <table className="table table-zebra w-full">
            <thead>
              <tr>
                <th className="bg-primary text-lg">From</th>
                <th className="bg-primary text-lg">to</th>
                <th className="bg-primary text-lg">Value</th>
                <th className="bg-primary text-lg">Pay</th>
              </tr>
            </thead>
            <tbody>
              {transfer != undefined ? (
                transfer.map(transfer => (
                  <tr key={transfer.from}>
                    <td className="text-left text-lg">
                      <Address address={transfer.from} />
                    </td>
                    <td className="text-left text-lg">
                      <Address address={transfer.to} />
                    </td>
                    <td className="text-left text-lg">{formatValue(transfer.value)}</td>
                    {connectedAddress == transfer.from ? (
                      <td className="text-left text-lg">
                        <button
                          className="btn btn-primary uppercase"
                          onClick={async () => {
                            try {
                              await writeProjectAsync({
                                functionName: "sendMoney",
                                args: [transfer.from, transfer.to, i],
                                value: transfer.value,
                              });
                            } catch (err) {
                              console.error("Error calling payInsuranceFee function", err);
                            }
                          }}
                        >
                          💸 Pay
                        </button>{" "}
                      </td>
                    ) : (
                      <td className="text-left text-lg"></td>
                    )}
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

export default Balances;
