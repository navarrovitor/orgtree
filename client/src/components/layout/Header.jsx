import ThemeToggle from '../common/ThemeToggle';

function Header() {
  return (
    <header className="bg-slate-800 p-4 shadow-md flex justify-between items-center fixed top-0 left-0 right-0 z-10">
      <a
        href="/"
        rel="noopener noreferrer"
        className="text-2xl font-bold text-white"
      >OrgTree 🌳</a>
      <ThemeToggle />
    </header>
  );
}

export default Header;