import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {

    function likeme(event, postId) {
      event.preventDefault();

      $.ajax({
        url: "/posts/" + postId + "/like",
        type: "put",
        success: function (response) {
          // update likes count
          document.getElementById("likes-count").textContent =
            response.likes_count;
        },
        error: function (error) {
          console.log(error);
        },
      });
    }
  }
}