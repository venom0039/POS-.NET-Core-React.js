import {BrowserRouter as Router, Routes, Route} from "react-router-dom"

import Home from './component/Home';
import Login from './component/Login';
import Dashboard from './component/Dashboard';
import Users from './component/User';
import Items from './component/Item';
import Stock from './component/Stock';
import Supplier from './component/Supplier';
import GRN from './component/GRN';
import Bill from './component/Bill';
import Return from './component/Return';

function App() {
  return (
    <div className="App">
      <Router>
        <Routes>
          <Route path="/" element={<Home/>} />
          <Route path="/login" element={<Login/>} />
          <Route path="/dashboard" element={<Dashboard/>} />
          <Route path="/dashboard/user" element={<Users/>} />
          <Route path="/dashboard/item" element={<Items/>} />
          <Route path="/dashboard/stock" element={<Stock/>} />
          <Route path="/dashboard/supplier" element={<Supplier/>} />
          <Route path="/dashboard/grn" element={<GRN/>} />
          <Route path="/dashboard/bill" element={<Bill/>} />
          <Route path="/dashboard/return" element={<Return/>} />
        </Routes>
      </Router>
    </div>
  );
}

export default App;
