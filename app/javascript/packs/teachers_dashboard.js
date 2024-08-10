document.addEventListener('turbolinks:load', function() {
    var modal = document.getElementById("addStudentModal");
    var editModal = document.getElementById("editStudentModal");
    var addBtn = document.getElementById("openModalBtn");
    var closeButtons = document.getElementsByClassName("close");

    addBtn.onclick = function() {
        modal.style.display = "block";
    }

    for (var i = 0; i < closeButtons.length; i++) {
        closeButtons[i].onclick = function() {
            modal.style.display = "none";
            editModal.style.display = "none";
        }
    }

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        } else if (event.target == editModal) {
            editModal.style.display = "none";
        }
    }
});
