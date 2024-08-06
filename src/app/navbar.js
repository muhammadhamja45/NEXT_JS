"use client"; 

import { useState } from 'react'; // Impor useState dari react
import Link from 'next/link';

export default function Navbar() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  return (
    <nav className="bg-gray-800 p-4">
      <div className="container mx-auto flex justify-between items-center">
        <div className="text-white text-xl font-bold">MyApp</div>
        <div className="hidden md:flex space-x-4">
          <Link href="/profil" className="text-white hover:text-gray-400">
            Profil
          </Link>
          <Link href="/about" className="text-white hover:text-gray-400">
            About
          </Link>
        </div>
        <div className="md:hidden">
          <button
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            className="text-white focus:outline-none"
          >
            <svg
              className="w-6 h-6"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M4 6h16M4 12h16M4 18h16"
              />
            </svg>
          </button>
        </div>
      </div>
      {/* Dropdown Mobile Menu */}
      {isMenuOpen && (
        <div className="md:hidden bg-gray-800">
          <Link href="/profil" className="block px-4 py-2 text-white hover:bg-gray-700">
            Profil
          </Link>
          <Link href="/about" className="block px-4 py-2 text-white hover:bg-gray-700">
            About
          </Link>
        </div>
      )}
    </nav>
  );
}
