// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract acl{
    bytes32 public constant ADMIN=keccak256(abi.encodePacked("ADMIN"));
    bytes32 public constant USER=keccak256(abi.encodePacked("USER"));

    event RoleGranted(address indexed account,bytes32 role );
    event Rolereomve(address indexed account,bytes32 role );
    mapping (bytes32 => mapping (address => bool)) public Auth;
    mapping (address => string) public Rolemap;

    constructor(){
        Auth[ADMIN][msg.sender] = true;
    }

    modifier cap(bytes32  _role){
        require(Auth[_role][msg.sender],"Account is Invalid");
        _;
    }

    function _grantRole(bytes32 role,address account) external cap(ADMIN){
        Auth[role][account]=true;
        Rolemap[account] = 
        emit RoleGranted(account ,role);
    } 

    function _removeRole(bytes32 role,address account) external cap(ADMIN){
        Auth[role][account]=false;
        emit Rolereomve(account ,role);
    } 

    function checkrole(address account) external {

    }

}