import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Stimulus is working i think");
  }
  likeme(event) {

    const postId = event.currentTarget.dataset.postId;
    alert("you are connected");
    event.preventDefault();
    console.log("hey u have clicked the  button");

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


// likepost_controller.js
// import { Controller } from "stimulus";

// export default class extends Controller {
//   static targets = ["likesCount"];

//   likeme(event) {
//     const postId = event.currentTarget.dataset.postId;

//     fetch(`/posts/${postId}/like`, {
//       method: "PUT"
//     })
//       .then(response => response.json())
//       .then(data => {
//         this.likesCountTarget.textContent = data.likes_count;
//       })
//       .catch(error => {
//         console.error("Error:", error);
//       });
//   }
// }