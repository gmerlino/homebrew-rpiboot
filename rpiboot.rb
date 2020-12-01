class Rpiboot < Formula
  desc "Raspberry Pi USB booting code"
  homepage "https://github.com/raspberrypi/usbboot"

  head do
    url "https://github.com/raspberrypi/usbboot.git"

    depends_on "libusb" => :build
    depends_on "pkg-config" => :build
  end

  patch :p0, :DATA

  def install
    ENV.append_path "PKG_CONFIG_PATH", Formula["libusb"].opt_lib/"pkgconfig"
    ENV.append "CFLAGS", "-I"+`pkg-config --variable includedir libusb-1.0`.chomp
    ENV.append "LDFLAGS", `pkg-config --libs libusb-1.0`.chomp
    system "make"
    bin.install "rpiboot"
  end

  test do
    assert_match "rpiboot", shell_output("#{bin}/rpiboot -help 2>&1", 255)
  end
end

__END__
diff --git a/Makefile.orig b/Makefile
index 6d8dc6a..0a3d4e7 100755
--- Makefile.orig
+++ Makefile
@@ -1,5 +1,5 @@
 rpiboot: main.c msd/bootcode.h msd/start.h msd/bootcode4.h msd/start4.h
-	$(CC) -Wall -Wextra -g -o $@ $< -lusb-1.0
+	$(CC) -Wall -Wextra -g -o $@ $< $(CFLAGS) $(LDFLAGS)

 %.h: %.bin ./bin2c
 	./bin2c $< $@
