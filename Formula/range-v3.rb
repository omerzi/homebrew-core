class RangeV3 < Formula
  desc "Experimental range library for C++14/17/20"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/0.12.0.tar.gz"
  sha256 "015adb2300a98edfceaf0725beec3337f542af4915cec4d0b89fa0886f4ba9cb"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "910a1185936fdfed478e1db229dc4960479508056ab50c482cfd7816de26d57c"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".",
                    "-DRANGE_V3_TESTS=OFF",
                    "-DRANGE_V3_HEADER_CHECKS=OFF",
                    "-DRANGE_V3_EXAMPLES=OFF",
                    "-DRANGE_V3_PERF=OFF",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <range/v3/all.hpp>
      #include <iostream>
      #include <string>

      int main() {
        std::string s{ "hello" };
        ranges::for_each( s, [](char c){ std::cout << c << " "; });
        std::cout << std::endl;
      }
    EOS
    stdlib_ldflag = OS.mac? ? "-lc++" : "-lstdc++"
    flags = [stdlib_ldflag]
    flags << "-stdlib=libc++" if OS.mac?
    system ENV.cc, "test.cpp", "-std=c++14", *flags, "-o", "test"
    assert_equal "h e l l o \n", shell_output("./test")
  end
end
