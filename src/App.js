import "./App.css";
import { useState } from "react";
import { ethers } from "ethers";
import TitreImmobilier from "./artifacts/contracts/TitreImmobilier.sol/TitreImmo.json";

// Update with the contract address logged out to the CLI when it was deployed
const titreImmoAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

function App() {
  // store greeting in local state
  const [titreImmo, setTitreImmoValue] = useState();

  // request access to the user's MetaMask account
  async function requestAccount() {
    await window.ethereum.request({ method: "eth_requestAccounts" });
  }

  // call the smart contract, read the current TitreImmo value
  async function fetchTitreImmoDescrip() {
    if (typeof window.ethereum !== "undefined") {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const contract = new ethers.Contract(
        titreImmoAddress,
        TitreImmobilier.abi,
        provider
      );
      try {
        const data = await contract.descriptionOf();
        console.log("data: ", data);
      } catch (err) {
        console.log("Error: ", err);
      }
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <button onClick={fetchTitreImmoDescrip}>
          Fetch the description of the titreImmo
        </button>
      </header>
    </div>
  );
}

export default App;
