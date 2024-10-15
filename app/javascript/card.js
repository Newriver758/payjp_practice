const pay = () => {
  const payjp = Payjp('pk_test_450197aae1704f64dd258cc8')
  const form = document.getElementById('charge-form')
  form.addEventListener("submit", (e) => {
    console.log("フォーム送信時にイベント発火")
    e.preventDefault();
  });
};

window.addEventListener("turbo:load", pay);