import Link from 'next/link';
import About from './about/page';
import Profil from './profil/page';

export default function Navbar() {
  return (
    <nav className="bg-gray-800 p-4">
      <div className="container mx-auto flex justify-between items-center">
        <div className="text-white text-xl font-bold">MyApp</div>
        <div className="flex space-x-4">
          <Link href="/profil" className="text-white hover:text-gray-400">
            Profil
          </Link>
          <Link href="/about" className="text-white hover:text-gray-400">
            About
          </Link>
        </div>
      </div>
    </nav>
  );
}
