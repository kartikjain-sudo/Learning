import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-contract-sizer";

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.17",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  defaultNetwork: "localhost",
  networks: {
    hardhat: {
      gas: "auto",
      gasPrice: "auto",
      loggingEnabled: false,
      mining: {
        mempool: {
          order: "fifo",
        },
      },
      forking: {
        url: process.env.ARCHIVE_NODE || "",
      },
    },
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    mumbai: {
      url: process.env.POLYGON_URL_MUMBAI || "",
      // accounts: (process.env.PRIVATE_KEY !== undefined)?[process.env.PRIVATE_KEY]:[],
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
    gasPrice: 30,
    coinmarketcap: process.env.COINMARKETCAP_KEY,
    url: "http://localhost:8545",
  },
  etherscan: {
    apiKey: process.env.POLYGON_API_KEY,
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: false,
    strict: true,
    // only: [':ERC20$'],
  },
};

export default config;
