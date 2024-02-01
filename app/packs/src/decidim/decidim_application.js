// This file is compiled inside Decidim core pack. Code can be added here and will be executed
// as part of that pack

import "iframe-resizer"
// Load images
require.context("../../images", true)

iFrameResize({ log: true }, '.auto-height-iframe')

document.addEventListener("DOMContentLoaded", () => {
  document.querySelector(".js-limit-amendment-follow-proposal").addEventListener("click", (evt) => {
  	evt.preventDefault();
  	const button = document.querySelector('.view-side form[action="/follow"] button')
		if(button.querySelector('.text-wrap').innerText.indexOf("Follow") == 0) {
			button.click();
		}
	});
});