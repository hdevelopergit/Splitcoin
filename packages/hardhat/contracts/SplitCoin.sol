//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

// Use openzeppelin to inherit battle-tested implementations (ERC20, ERC721, etc)
// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
/**
 * A smart contract that allows changing a state variable of the contract and tracking the changes
 * It also allows the owner to withdraw the Ether in the contract
 * @author BuidlGuidl
 */
contract SplitCoin {
	// Used for getter
	struct Expense {
		string expenseDesc;
		address expender;
		uint256 value;
	}

	// Used for getter
	struct TransferMov {
		address from;
		address to;
		uint256 value;
	}

	mapping(string => mapping(address => uint256)) public expenses;
	mapping(address => int256) public balances;
	mapping(address => mapping(address => uint256)) public transfer;
	uint256 public totalMov;
	address[] public expender;
	string[] public expensesDesc;
	address public owner;
	bool contractClosed = false;

	constructor(address _initialOwner) {
		console.log("initial owner", _initialOwner);
		owner = _initialOwner;

		expender.push(_initialOwner);
	}

	function getOwner() public view returns (address) {
		return owner;
	}

	function sendMoney(address _from, address payable _to) public payable {
		(bool sent, bytes memory data) = _to.call{ value: msg.value }("");
		require(sent, "Failed to send money");

		transfer[_from][_to] = 0;
		totalMov--;
	}

	function wipe2balances() private returns (bool) {
		bool transferFlag = false;

		console.log("wipe2balances");
		for (uint256 i = 0; i < expender.length - 1; i++) {
			for (uint256 j = i + 1; j < expender.length; j++) {
				if (balances[expender[i]] != 0) {
					// if 0 there is no need for transfer
					int256 tmp_result = balances[expender[i]] +
						balances[expender[j]];
					if (tmp_result == 0) {
						// balances match
						if (balances[expender[i]] < 0) {
							balances[expender[i]] = balances[expender[i]] * -1;
							transfer[expender[i]][expender[j]] = uint256(
								balances[expender[i]]
							);
						} else {
							balances[expender[j]] = balances[expender[j]] * -1;
							transfer[expender[j]][expender[i]] = uint256(
								balances[expender[j]]
							);
						}
						// Set to zero the corresponding balances
						balances[expender[i]] = 0;
						balances[expender[j]] = 0;
						totalMov++;
						transferFlag = true;
					}
				}
			}
		}

		return transferFlag;
	}

	function wipeAnyBalance() private returns (bool) {
		int256 tmp_balance;
		int256 tmp_bal_i;
		int256 tmp_bal_j;

		bool transferFlag = false;

		console.log("wipeAnyBalance");
		for (uint256 i = 0; i < expender.length - 1; i++) {
			console.log("i: ", i);
			for (uint256 j = i + 1; j < expender.length; j++) {
				console.log("j: ", j);
				if (
					(balances[expender[i]] > 0 && balances[expender[j]] < 0) ||
					(balances[expender[i]] < 0 && balances[expender[j]] > 0)
				) {
					console.log("1er if");
					tmp_bal_i = balances[expender[i]];
					tmp_bal_j = balances[expender[j]];
					if (tmp_bal_i < 0) tmp_bal_i = tmp_bal_i * -1;
					if (tmp_bal_j < 0) tmp_bal_j = tmp_bal_j * -1;
					if (balances[expender[i]] < 0 && tmp_bal_i < tmp_bal_j) {
						console.log("2do if");
						tmp_balance = balances[expender[i]] * -1;
						transfer[expender[i]][expender[j]] = uint256(
							tmp_balance
						);
						totalMov++;
						balances[expender[j]] =
							balances[expender[i]] +
							balances[expender[j]];
						balances[expender[i]] = 0;
						transferFlag = true;
					}
					if (balances[expender[j]] < 0 && tmp_bal_j < tmp_bal_i) {
						console.log("3er if");
						tmp_balance = balances[expender[j]] * -1;
						transfer[expender[j]][expender[i]] = uint256(
							tmp_balance
						);
						totalMov++;
						balances[expender[i]] =
							balances[expender[i]] +
							balances[expender[j]];
						balances[expender[j]] = 0;
						transferFlag = true;
					}
				}
			}
		}

		return transferFlag;
	}

	function wipeRemainingBalance() private returns (bool) {
		int256 tmp_bal_i;
		int256 tmp_bal_j;
		bool transferFlag = false;

		console.log("wipeRemainingBalance");
		for (uint256 i = 0; i < expender.length - 1; i++) {
			console.log("i: ", i);
			for (uint256 j = i + 1; j < expender.length; j++) {
				console.log("j: ", j);
				if (
					(balances[expender[i]] > 0 && balances[expender[j]] < 0) ||
					(balances[expender[i]] < 0 && balances[expender[j]] > 0)
				) {
					console.log("1er if");
					tmp_bal_i = balances[expender[i]];
					tmp_bal_j = balances[expender[j]];
					if (tmp_bal_i < 0) tmp_bal_i = tmp_bal_i * -1;
					if (tmp_bal_j < 0) tmp_bal_j = tmp_bal_j * -1;
					if (balances[expender[i]] < 0) {
						console.log("2do if");

						transfer[expender[i]][expender[j]] = uint256(
							balances[expender[j]]
						);
						totalMov++;
						balances[expender[i]] =
							balances[expender[i]] +
							balances[expender[j]];
						balances[expender[j]] = 0;
						transferFlag = true;
					}
					if (balances[expender[j]] < 0) {
						console.log("3er if");
						transfer[expender[j]][expender[i]] = uint256(
							balances[expender[i]]
						);
						totalMov++;
						balances[expender[j]] =
							balances[expender[j]] +
							balances[expender[i]];
						balances[expender[i]] = 0;
						transferFlag = true;
					}
				}
			}
		}

		return transferFlag;
	}

	function check_balance_zero() private view returns (bool) {
		for (uint256 i = 0; i < expender.length; i++)
			if (balances[expender[i]] != 0) return false;

		return true;
	}

	function calculateTransfers() public {
		bool transferFlag;
		bool transferFlagAny;

		require(
			check_balance_zero() == false,
			"There is no balances to calculate!"
		);

		while (check_balance_zero() == false) {
			// 1) if you can wipe out 2 balances, do it
			transferFlag = wipe2balances();
			// 2) otherwise if you can wipe out one balance
			transferFlagAny = wipeAnyBalance();

			if (transferFlag == false && transferFlagAny == false) {
				if (wipeRemainingBalance() == false) break;
			}
		}

		contractClosed = true;
	}

	function getTransfers() public view returns (TransferMov[] memory) {
		TransferMov[] memory tmpTransfers = new TransferMov[](totalMov);
		uint256 k = 0;

		for (uint256 i = 0; i < expender.length - 1; i++) {
			for (uint256 j = i + 1; j < expender.length; j++) {
				if (transfer[expender[i]][expender[j]] > 0) {
					console.log("add element i");
					tmpTransfers[k] = TransferMov(
						expender[i],
						expender[j],
						transfer[expender[i]][expender[j]]
					);
					k++;
				}
				if (transfer[expender[j]][expender[i]] > 0) {
					console.log("add element j");
					tmpTransfers[k] = TransferMov(
						expender[j],
						expender[i],
						transfer[expender[j]][expender[i]]
					);
					k++;
				}
			}
		}

		return tmpTransfers;
	}

	function saveExpenses(string memory _desc, uint256 _value, address _expender) public {

		require(expender.length > 1, "There must be more than one participant!");
		require(contractClosed == false, "Contract was calculated. Can not be re-used.");

		if (expenses[_desc][_expender] > 0)
			expenses[_desc][_expender] += _value;
		else {
			// expender.push(msg.sender);
			expensesDesc.push(_desc);
			expenses[_desc][_expender] = _value;
		}

		// update balance
		balances[_expender] +=
			int256(_value) -
			int256(_value / expender.length);
		for (uint256 j = 0; j < expender.length; j++) {
			if (expender[j] != _expender)
				balances[expender[j]] -= int256(_value / expender.length);
		}
	}

	function saveAddress(address _participant) public {
		bool repeated = false;

		require(expensesDesc.length == 0, "Expenses were entered already, you can't add participants");

		for(uint256 i=0; i<expender.length; i++) {
			if (expender[i] == _participant) {
				repeated = true;
				break;
			}
		}

		require(repeated == false, "Participant exists already");
		expender.push(_participant);
	}

	function getAddress() public view returns (address[] memory) {
		return expender;
	}

	function getExpenses() public view returns (Expense[] memory) {
		Expense[] memory tmpExpenses = new Expense[](expensesDesc.length);

		for (uint256 i = 0; i < expensesDesc.length; i++) {
			for (uint256 j = 0; j < expender.length; j++) {
				if (expenses[expensesDesc[i]][expender[j]] > 0)
					tmpExpenses[i] = Expense(
						expensesDesc[i],
						expender[j],
						expenses[expensesDesc[i]][expender[j]]
					);
			}
		}
		return tmpExpenses;
	}
}
