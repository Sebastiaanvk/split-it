pragma solidity ^0.4.0;

contract SplitIt {

    address[] employees = [0xcBFc2Df5c8b89Bb2D8c3f38dB8d11ddD2e63dC89,
                            0x9b295eE2aBdDec61cF7BB480266079572ceB68dB,
                            0xa5472233A9FF8409107EF5d71B58f92539b11274,
                            0x88cc3F2D07B0131F8109E035B62A3BddC7F07526,
                            0x9abD2d87aD1f4ae6D9E49C41DD1fB8B65306Fa4f];

    uint totalReceived = 0;
    mapping (address => uint) withdrawnAmounts;

    function SplitIt() payable {
        updateTotalReceived();
    }

    function () payable {
        updateTotalReceived();
    }

    function updateTotalReceived() internal {
        totalReceived += msg.value;
    }

    modifier canWithdraw() {
        bool contains = false
        for(uint i = 0; i < employees.length; i++) {
          if(employees[i] == msg.sender) {
            contains = true;
          }
        }
        require(contains);
        _;
    }

    function withdraw() canWithdraw {
        uint amountAllocated = totalReceived/employees.length;
        uint amountWithdrawn = withdrawnAmounts[msg.sender];
        uint amount = amountAllocated - amountWithdrawn;
        withdrawnAmounts[msg.sender] = amountWithdrawn + amount;

        if (amount > 0) {
          msg.sender.transfer(amount);
        }
    }

}
