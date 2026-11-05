// lumo-upload-images.js
// Run: node lumo-upload-images.js
// Uploads 60 curated property images to Cloudinary under the lumo/properties/ folder.
// Prints a JSON map of { slug: cloudinary_url } when done.

const cloudinary = require('cloudinary').v2;

cloudinary.config({
  cloud_name: 'vf4zqyla',
  api_key: '648319944154186',
  api_secret: 'gPOtzDi_dYwzywIP3_DT8QwfGjQ',
});

// 60 unique Unsplash property images — no duplicates.
// Grouped by type for easy mapping to seed data.
const images = [
  // ── Apartments exterior (10) ──────────────────────────────────────────
  { slug: 'apt_ext_01', url: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=1200&q=80' },
  { slug: 'apt_ext_02', url: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=1200&q=80' },
  { slug: 'apt_ext_03', url: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=1200&q=80' },
  { slug: 'apt_ext_04', url: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=1200&q=80' },
  { slug: 'apt_ext_05', url: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=1200&q=80' },
  { slug: 'apt_ext_06', url: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=1200&q=80' },
  { slug: 'apt_ext_07', url: 'https://images.unsplash.com/photo-1574362848149-11496d93a7c7?w=1200&q=80' },
  { slug: 'apt_ext_08', url: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200&q=80' },
  { slug: 'apt_ext_09', url: 'https://images.unsplash.com/photo-1567496898669-ee935f5f647a?w=1200&q=80' },
  { slug: 'apt_ext_10', url: 'https://images.unsplash.com/photo-1536376072261-38c75010e6c9?w=1200&q=80' },

  // ── Apartment interiors (10) ──────────────────────────────────────────
  { slug: 'apt_int_01', url: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=1200&q=80' },
  { slug: 'apt_int_02', url: 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?w=1200&q=80' },
  { slug: 'apt_int_03', url: 'https://images.unsplash.com/photo-1554995207-c18c203602cb?w=1200&q=80' },
  { slug: 'apt_int_04', url: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=1200&q=80' },
  { slug: 'apt_int_05', url: 'https://images.unsplash.com/photo-1600210492493-0946911123ea?w=1200&q=80' },
  { slug: 'apt_int_06', url: 'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=1200&q=80' },
  { slug: 'apt_int_07', url: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1200&q=80' },
  { slug: 'apt_int_08', url: 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?w=1200&q=80' },
  { slug: 'apt_int_09', url: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=1200&q=80' },
  { slug: 'apt_int_10', url: 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=1200&q=80' },

  // ── Villas (10) ───────────────────────────────────────────────────────
  { slug: 'villa_01', url: 'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=1200&q=80' },
  { slug: 'villa_02', url: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1200&q=80' },
  { slug: 'villa_03', url: 'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=1200&q=80' },
  { slug: 'villa_04', url: 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=1200&q=80' },
  { slug: 'villa_05', url: 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=1200&q=80' },
  { slug: 'villa_06', url: 'https://images.unsplash.com/photo-1576941089067-2de3c901e126?w=1200&q=80' },
  { slug: 'villa_07', url: 'https://images.unsplash.com/photo-1598228723793-52759bba239c?w=1200&q=80' },
  { slug: 'villa_08', url: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=1200&q=80' },
  { slug: 'villa_09', url: 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=1200&q=80' },
  { slug: 'villa_10', url: 'https://images.unsplash.com/photo-1523217582562-09d0def993a6?w=1200&q=80' },

  // ── Houses (10) ───────────────────────────────────────────────────────
  { slug: 'house_01', url: 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=1200&q=80' },
  { slug: 'house_02', url: 'https://images.unsplash.com/photo-1583608205776-bfd35f0d9f83?w=1200&q=80' },
  { slug: 'house_03', url: 'https://images.unsplash.com/photo-1558036117-15d82a90b9b1?w=1200&q=80' },
  { slug: 'house_04', url: 'https://images.unsplash.com/photo-1575517111839-3a3843ee7f5d?w=1200&q=80' },
  { slug: 'house_05', url: 'https://images.unsplash.com/photo-1592595896551-12b371d546d5?w=1200&q=80' },
  { slug: 'house_06', url: 'https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=1200&q=80' },
  { slug: 'house_07', url: 'https://images.unsplash.com/photo-1605276374104-dee2a0ed3cd6?w=1200&q=80' },
  { slug: 'house_08', url: 'https://images.unsplash.com/photo-1449844908441-8829872d2607?w=1200&q=80' },
  { slug: 'house_09', url: 'https://images.unsplash.com/photo-1463797221720-6b07e6426c24?w=1200&q=80' },
  { slug: 'house_10', url: 'https://images.unsplash.com/photo-1510627489930-0c1b0bfb6785?w=1200&q=80' },

  // ── Land (5) ──────────────────────────────────────────────────────────
  { slug: 'land_01', url: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=1200&q=80' },
  { slug: 'land_02', url: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200&q=80' },
  { slug: 'land_03', url: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80' },
  { slug: 'land_04', url: 'https://images.unsplash.com/photo-1418065460487-3e41a6c84dc5?w=1200&q=80' },
  { slug: 'land_05', url: 'https://images.unsplash.com/photo-1470770903676-69b98201ea1c?w=1200&q=80' },

  // ── Commercial / Office (10) ──────────────────────────────────────────
  { slug: 'commercial_01', url: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=1200&q=80' },
  { slug: 'commercial_02', url: 'https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=1200&q=80' },
  { slug: 'commercial_03', url: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=1200&q=80' },
  { slug: 'commercial_04', url: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200&q=80' },
  { slug: 'commercial_05', url: 'https://images.unsplash.com/photo-1541746972996-4e0b0f43e02a?w=1200&q=80' },
  { slug: 'office_01', url: 'https://images.unsplash.com/photo-1497215842964-222b430dc094?w=1200&q=80' },
  { slug: 'office_02', url: 'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=1200&q=80' },
  { slug: 'office_03', url: 'https://images.unsplash.com/photo-1556761175-4b46a572b786?w=1200&q=80' },
  { slug: 'office_04', url: 'https://images.unsplash.com/photo-1568992687947-868a62a9f521?w=1200&q=80' },
  { slug: 'office_05', url: 'https://images.unsplash.com/photo-1572025442646-866d16c84a54?w=1200&q=80' },

  // ── Extra interiors for variety (5) ───────────────────────────────────
  { slug: 'interior_01', url: 'https://images.unsplash.com/photo-1631679706909-1844bbd07221?w=1200&q=80' },
  { slug: 'interior_02', url: 'https://images.unsplash.com/photo-1615529328331-f8917597711f?w=1200&q=80' },
  { slug: 'interior_03', url: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=1200&q=80' },
  { slug: 'interior_04', url: 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=1200&q=80' },
  { slug: 'interior_05', url: 'https://images.unsplash.com/photo-1562663474-6cbb3eaa4d14?w=1200&q=80' },
];

async function upload(item) {
  try {
    const result = await cloudinary.uploader.upload(item.url, {
      public_id: `lumo/properties/${item.slug}`,
      overwrite: false,
      resource_type: 'image',
    });
    return { slug: item.slug, url: result.secure_url };
  } catch (err) {
    console.error(`  ✗ ${item.slug}: ${err.message}`);
    return { slug: item.slug, url: null };
  }
}

async function main() {
  console.log(`Uploading ${images.length} images to Cloudinary...\n`);

  // Upload in batches of 5 to avoid rate limits.
  const results = {};
  for (let i = 0; i < images.length; i += 5) {
    const batch = images.slice(i, i + 5);
    const settled = await Promise.all(batch.map(upload));
    for (const r of settled) {
      if (r.url) {
        results[r.slug] = r.url;
        console.log(`  ✓ ${r.slug}`);
      }
    }
  }

  console.log('\n── RESULTS ──────────────────────────────────────────');
  console.log(JSON.stringify(results, null, 2));
  console.log('\nCopy the JSON above — you will need it for the seed SQL.');
}

main();
