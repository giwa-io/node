![Giwa](/resources/logo.png)


# Giwa Node

<h4 align="center">
    <p>
        <a href="/README.md">English</a> |
        <b>Türkçe</b> |
    </p>
</h4>

**Giwa**, Optimism'in [OP Stack](https://stack.optimism.io/) yapısı üzerine kurulmuş bir Ethereum Layer 2 (Katman 2) ağıdır.  
Bu repository (depo), Giwa ağında kendi node’unuzu (düğümünüzü) çalıştırmak için ihtiyacınız olan her şeyi sağlar.

## 💡 Desteklenen Ağlar

| Ağ                | Durum |
|-------------------|-------|
| Mainnet           | 🚧    |
| Testnet (Sepolia) | ✅    |

## 🚀 Hızlı Başlangıç

1. Bir Ethereum L1 full node RPC’niz olduğundan emin olun
2. Ağınızı seçin
   - **Mainnet** için: *Çok yakında – mainnet şu anda geliştirme aşamasında.*
   - **Testnet (Sepolia)** için: `.env.sepolia` dosyasını kullanın
3. L1 uç noktalarınızı `.env` dosyasında yapılandırın. Ayrıca ağ, cache, logging, metrics gibi çalışma zamanı parametrelerini de `.env` dosyasında özelleştirebilirsiniz.
   ```bash
   OP_NODE_L1_ETH_RPC=<tercih-ettiğiniz-l1-eth-rpc>
   OP_NODE_L1_BEACON=<tercih-ettiğiniz-l1-beacon>
   ```
4. Derleme ve çalıştırma
   ```bash
   docker compose build --parallel
   NETWORK_ENV=<.env.{network}> docker compose up -d
   ```

5. Durdurma
   ```bash
   docker compose down
   ```

6. Temizlik
   ```bash
   docker compose down -v && rm -rf ./execution_data
   ```

## 🛠️ Yapılandırma

### Zorunlu Yapılandırma

| Değişken             | Açıklama                              |
|----------------------|---------------------------------------|
| `OP_NODE_L1_ETH_RPC` | Ethereum L1 node RPC uç noktanız      |
| `OP_NODE_L1_BEACON`  | L1 beacon node uç noktanız            |

### Senkronizasyon Seçenekleri

Tercihinize göre aşağıdaki senkronizasyon stratejilerinden birini seçin.  
> `.env` dosyanızda ilgili **OPTION** bloğunu etkinleştirin (aynı anda yalnızca bir tanesi).

#### 1) Snap Sync — Hızlı ve Pratik
- **Ne yapar:** Güncel bir state snapshot’ı indirir ve tüm geçmiş blokları yürütmeden mevcut başa senkronize olur.
- **Ne zaman kullanılır:** Üretim/full node’u hızlıca ayağa kaldırmak istediğinizde (RPC node’ları, follower node’lar).
- **Artı/Eksi:** En hızlı çevrim içi olma yöntemi; ancak derin tarihsel sorgular için uygun değildir.

#### 2) Archive Sync — Tam Geçmiş
- **Ne yapar:** Genesis’ten itibaren her bloğu yürütür ve **tüm geçmiş state’i (arşiv)** saklar.
- **Ne zaman kullanılır:** Indexer çalıştırmak, araştırma/hata ayıklama yapmak veya herhangi bir blokta tarihsel state’e erişmek gerektiğinde.
- **Artı/Eksi:** Çok daha yavaştır ve çok fazla disk alanı ister; günlük kullanım için çoğu operatöre gerekmez.

#### 3) Consensus-Driven Sync — Minimum Güven
- **Ne yapar:** Konsensüs client’ı, execution client’a unsafe bloklar ekleyerek senkronizasyonu yönlendirir; execution client için L2 peer discovery gerekmez.
- **Ne zaman kullanılır:** Replay tabanlı senkronizasyonu ve daha sıkı kontrolü tercih ettiğinizde (ör. L2 doğrulayıcı).
- **Artı/Eksi:** Snap’ten daha yavaş; kontrollü ortamlarda operasyonel olarak daha basittir.

## 💽 Veri Kalıcılığı

Varsayılan olarak, yürütme verileri `{PROJECT_ROOT}/execution_data` konumuna bağlanır.  
Bağlantı yolunu özelleştirmek için `$EXECUTION_DATA_DIR` ortam değişkenini ayarlayın.

## ⚙️ Donanım Gereksinimleri

### Testnet

| Kaynak | Minimum       | Önerilen |
|--------|---------------|----------|
| CPU    | 4 çekirdek    | 8+ çekirdek |
| RAM    | 8 GB          | 16+ GB   |
| Disk   | 500 GB (NVMe) | 1+ TB    |

## 🙋 Sorun Giderme

- Log’ları kontrol etmek için:
```bash
docker compose logs -f giwa-el
docker compose logs -f giwa-cl
```

## 🛑 Sorumluluk Reddi

BU YAZILIM “OLDUĞU GİBİ” SUNULMAKTADIR, HERHANGİ BİR GARANTİ VERİLMEZ.  
Bu node’u çalıştırarak altyapınız, güvenliğiniz ve uyumluluğunuzdan siz sorumlusunuz.

## 🌐 Giwa Topluluğuna Katılın

- 📖 Dokümantasyon: *Çok Yakında*
- 💬 Discord: *Çok Yakında*
- 🐦 Twitter: *Çok Yakında*
