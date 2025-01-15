//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./SplitCoin.sol";

contract Project {
	struct ProjectElement {
		string projectDesc;
		SplitCoin splitCoin;
	}

	struct ProjectElementTmp {
		uint256 index;
		string projectDesc;
	}

	ProjectElement[] public projectArr;
	// uint256 public index;

	constructor(address initialOwner) {}

	function getSmartContract(uint256 _index) public view returns (SplitCoin) {
		return projectArr[_index].splitCoin;
	}

	// function getExpenses(uint256 i) public view returns (SplitCoin.Expense[] memory) {
	// }

	function getAddress(bool _selectedProject, uint256 _i) public view returns (address[] memory) {
		require(_selectedProject == true, "Project not selected");
		return projectArr[_i].splitCoin.getAddress();
	}

	function saveExpenses(
		string memory _desc,
		uint256 _value,
		uint256 _i,
		address _expender
	) public {
		projectArr[_i].splitCoin.saveExpenses(_desc, _value, _expender);
	}

	function saveAddress(address _participant, uint256 _i) public {
		projectArr[_i].splitCoin.saveAddress(_participant);
	}

	function getExpenses(
		bool _selectedProject,
		uint256 _i
	) public view returns (SplitCoin.Expense[] memory) {
		require(_selectedProject == true, "Project not selected");
		return projectArr[_i].splitCoin.getExpenses();
	}

	function newProject(string memory _projectDesc) public {
		ProjectElement memory project;
		project.projectDesc = string.concat(
			Strings.toString(projectArr.length),
			" - ",
			_projectDesc
		);
		// project.projectDesc = _projectDesc;
		project.splitCoin = new SplitCoin(msg.sender);
		projectArr.push(project);
	}

	function getProjects(
		address _sender
	) public view returns (string[] memory) {
		string[] memory projectArrTmp = new string[](projectArr.length);
		uint256 k = 0;

		for (uint256 i = 0; i < projectArr.length; i++) {
			if (_sender == projectArr[i].splitCoin.getOwner()) {
				// is the owner, save
				projectArrTmp[k] = projectArr[i].projectDesc;
				k++;
			} else {
				for (
					uint256 j = 0;
					j < projectArr[i].splitCoin.getAddress().length;
					j++
				) {
					if (_sender == projectArr[i].splitCoin.getAddress()[j]) {
						projectArrTmp[k] = projectArr[i].projectDesc; // if I found as expender, save the project
						k++;
						break;
					}
				}
			}
		}

		return projectArrTmp;
	}

	function getTransfers(
		bool _selectedProject,
		uint256 _i
	) public view returns (SplitCoin.TransferMov[] memory) {
		require(_selectedProject == true, "Project not selected");
		return projectArr[_i].splitCoin.getTransfers();
	}

	function calculateTransfers(uint256 _i) public {
		projectArr[_i].splitCoin.calculateTransfers();
	}

	function sendMoney(address _from, address payable _to, uint256 _i) public payable {
		projectArr[_i].splitCoin.sendMoney{value: msg.value}(_from, _to);
	}
}
