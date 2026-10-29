// 관람객 안내자료 PDF 만들기: handout.html → handout.pdf (A4 2장)
//   node docs/handout/make_pdf.js        (playwright 필요: npm i playwright && npx playwright install chromium)
//   또는 크롬으로 handout.html 열기 → 인쇄 → PDF로 저장 (여백 없음, 배경 그래픽 켜기)
const path = require('path');
const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto('file://' + path.join(__dirname, 'handout.html'));
  await page.evaluate(() => document.fonts.ready);
  await page.pdf({ path: path.join(__dirname, 'handout.pdf'), format: 'A4', printBackground: true,
    margin: { top: '0', right: '0', bottom: '0', left: '0' } });
  await page.screenshot({ path: path.join(__dirname, 'preview.png'), fullPage: true });
  await browser.close();
  console.log('docs/handout/handout.pdf');
})();
