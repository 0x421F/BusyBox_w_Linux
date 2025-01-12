# BusyBox with Linux

Bu proje, BusyBox ve Linux çekirdeğini kullanarak minimalist bir Linux sistemi oluşturmayı amaçlamaktadır.

## İçindekiler

- [Özellikler](#özellikler)
- [Gereksinimler](#gereksinimler)
- [Kurulum](#kurulum)
- [Kullanım](#kullanım)
- [Katkıda Bulunma](#katkıda-bulunma)
- [Lisans](#lisans)

## Özellikler

- **Minimalist Yapı:** Gereksiz bileşenlerden arındırılmış, sadece temel işlevleri içeren bir sistem.
- **BusyBox Entegrasyonu:** Birçok Unix aracını tek bir ikili dosyada sunarak sistem boyutunu küçültür.
- **Özelleştirilebilir:** İhtiyaçlarınıza göre yapılandırılabilir ve genişletilebilir.

## Gereksinimler

- **Linux Çekirdeği:** Projede kullanılan `bzImage` dosyası, derlenmiş Linux çekirdeğini içerir.
- **BusyBox:** `busybox.sh` betiği, BusyBox'ın yapılandırılması ve kurulumu için kullanılır.
- **İlk Ramdisk (initrd):** `initrd` dizini ve `initrd.img` dosyası, başlangıçta yüklenen geçici dosya sistemini sağlar.

## Kurulum

1. **Depoyu Klonlayın:**

   ```bash
   git clone https://github.com/0x421F/BusyBox_w_Linux.git
   cd BusyBox_w_Linux
   ```

2. **BusyBox'ı Kurun:**

   ```bash
   chmod +x busybox.sh
   ./busybox.sh
   ```

   Bu betik, BusyBox'ı indirir, yapılandırır ve `initrd` dizinine kurar.

3. **İlk Ramdisk'i Oluşturun:**

   ```bash
   cd initrd
   find . | cpio -o --format=newc > ../initrd.img
   cd ..
   ```

   Bu komutlar, `initrd` dizinindeki dosyaları kullanarak `initrd.img` dosyasını oluşturur.

4. **Sistemi Önyükleyin:**

   Önyükleme işlemi için `bzImage` ve `initrd.img` dosyalarını kullanabilirsiniz. Örneğin, QEMU ile:

   ```bash
   qemu-system-x86_64 -kernel bzImage -initrd initrd.img -append "console=ttyS0" -nographic
   ```

   Bu komut, sistemi sanal bir ortamda başlatacaktır.

## Kullanım

Sistem önyüklendikten sonra, BusyBox'ın sağladığı temel Unix komutlarını kullanabilirsiniz.

## Katkıda Bulunma

Katkılarınızı memnuniyetle karşılıyoruz. Lütfen bir pull request oluşturun veya bir issue açın.

## Lisans

Bu proje [MIT Lisansı](LICENSE) ile lisanslanmıştır.
