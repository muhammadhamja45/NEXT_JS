import Link from 'next/link';

export default function Sidebar() {
  return (
    <div className="w-64 h-screen bg-gray-800 text-white flex flex-col">
      <div className="p-4 font-bold text-lg">Sidebar Title</div>
      <nav className="flex flex-col p-4 space-y-2">
        <Link href="/" className="hover:bg-gray-700 p-2 rounded">
          Home
        </Link>
        <Link href="/about" className="hover:bg-gray-700 p-2 rounded">
          About
        </Link>
        <Link href="/services" className="hover:bg-gray-700 p-2 rounded">
          Services
        </Link>
        <Link href="/contact" className="hover:bg-gray-700 p-2 rounded">
          Contact
        </Link>
      </nav>
    </div>
  );
}
