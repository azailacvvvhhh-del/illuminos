<script>
function toggleFavorite(event, contentId) {
    event.preventDefault(); // Отменяем стандартную отправку формы
    const form = document.getElementById('fav-form-' + contentId);
    const btn = document.getElementById('fav-btn-' + contentId);
    const formData = new FormData(form);

    // Отправляем запрос на сервер (в наш favorite_action.php)
    fetch('favorite_action.php', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        // Меняем текст и стиль кнопки в зависимости от текущего состояния
        if (btn.innerText.includes('♡')) {
            btn.innerHTML = '♥ В избранном';
            btn.style.color = '#e0446b'; // Красим в красный
            btn.style.borderColor = '#e0446b';
        } else {
            btn.innerHTML = '♡ В избранное';
            btn.style.color = 'var(--accent)';
            btn.style.borderColor = '#d6d3fb';
        }
    })
    .catch(error => console.error('Ошибка:', error));
}
</script>