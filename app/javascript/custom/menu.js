// Menu manipulation

//Add toggle listeners to listen for clicks.
document.addEventListener("turbo:load", () => {
	let account = document.querySelector("#account");
	account.addEventListener("click", event => {
		event.preventDefault();
		let menu = document.querySelector("#dropdown-menu");
		menu.classList.toggle("active");
	})
})