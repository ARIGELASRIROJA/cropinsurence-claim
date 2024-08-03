pragma solidity 0.8.19;

contract AgricultureSchemes {
    struct Farmer {
        uint id;
        string name;
        bool registered;
    }

    struct Scheme {
        uint id;
        string name;
        string description;
        uint fund;
    }

    struct Claim {
        uint id;
        uint schemeId;
        uint farmerId;
        string description;
        uint amount;
        bool approved;
    }

    address public admin;
    uint public farmerCount;
    uint public schemeCount;
    uint public claimCount;

    mapping(uint => Farmer) public farmers;
    mapping(uint => Scheme) public schemes;
    mapping(uint => Claim) public claims;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerFarmer(string memory _name) public {
        farmerCount++;
        farmers[farmerCount] = Farmer(farmerCount, _name, true);
    }

    function createScheme(string memory _name, string memory _description, uint _fund) public onlyAdmin {
        schemeCount++;
        schemes[schemeCount] = Scheme(schemeCount, _name, _description, _fund);
    }

    function submitClaim(uint _schemeId, uint _farmerId, string memory _description, uint _amount) public {
        require(farmers[_farmerId].registered, "Farmer not registered");
        require(_amount <= schemes[_schemeId].fund, "Insufficient funds in scheme");

        claimCount++;
        claims[claimCount] = Claim(claimCount, _schemeId, _farmerId, _description, _amount, false);
    }

    function approveClaim(uint _claimId) public onlyAdmin {
        Claim storage claim = claims[_claimId];
        require(claim.amount <= schemes[claim.schemeId].fund, "Insufficient funds in scheme");

        claim.approved = true;
        schemes[claim.schemeId].fund -= claim.amount;
    }

    function getFarmer(uint _id) public view returns (Farmer memory) {
        return farmers[_id];
    }

    function getScheme(uint _id) public view returns (Scheme memory) {
        return schemes[_id];
    }

    function getClaim(uint _id) public view returns (Claim memory) {
        return claims[_id];
    }
}