import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // this.element.textContent = "Hello World!"

    // function likeme() {
    //   $.ajax({
    //     binding.pry,
    //     url: '/like_post_path',
    //     type: 'put',
    //     data: { random_param: " You Liked this Post" }, dataType: "", success: function (response) {
    //       var
    //         response = data.random_param_name; alert("Response is=> " + response)
    //     },
    //     error: function (error) { console.log(error) }
    //   }); success: function (response) {
    //     // assuming response.likes_count contains the updated likes count
    //     document.getElementById('likes-count').textContent = response.likes_count;
    //   },
    // }
    function likeme() {
      $.ajax({
        binding.pry,
        url: '/like_post_path',
        type: 'put',
        data: { random_param: " You Liked this Post" },
        dataType: "",
        success: function (response) {
          // assuming response.likes_count contains the updated likes count
          document.getElementById('likes-count').textContent = response.likes_count;
        },
        error: function (error) {
          console.log(error)
        }
      });
    }
    

  }
}