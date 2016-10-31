<div class="guide-profile-welcome">

</div>
<div class="guide-profile-text-overlay">

    <a class="guide-profile-close" href="#" id="close-welcome"><@trans key="thub.guide.profile.box_close" default="close"/></a>

    <h3><@trans key="thub.guide.profile.welcome" default="Welcome to Your Profile"/></h3>

    <div class="guide-profile-text">
        <@trans key="thub.guide.profile.box_text" default="It looks like you haven't personalized your profile yet. You can start by uploading a new avatar and telling us a bit more about yourself. Then you can start participating in the community by:"/>

          <ul>
          <li><@trans key="thub.guide.profile.box_text2" default="Following people, topics and spaces"/></li>
          <li><@trans key="thub.guide.profile.box_text3" default="Adding content like questions and answers"/></li>
          <li><@trans key="thub.guide.profile.box_text4" default="Earning reputation points and badges"/></li>
          </ul>
    </div>
</div>
<script type="text/javascript">

    $(function() {
        $('#close-welcome').click(function() {
            $('.guide-profile-welcome, .guide-profile-text-overlay').remove();
            return false;
        });
    });
</script>
