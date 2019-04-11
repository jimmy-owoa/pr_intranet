id:  3,
title:  "Elon Musk y The Boring Company muestran su sistema de túneles en acción",
 slug:  "slug-6535",
content:  "<p>The Boring Company abri&oacute; su primera l&iacute;nea de transporte para que los mortales conozcamos el futuro del desplazamiento.</p>",
status:  "Publicado",
published_at:  Fri, 05 Apr 2019 17:15:00 -03 -03:00,
main_image_id:  1,
term_id:  nil,
post_parent_id:  nil,
visibility:  "Público",
post_class:  "tipo",
post_order:  nil,
created_at:  Thu, 04 Apr 2019 17:25:49 -03 -03:00,
updated_at:  Thu, 11 Apr 2019 12:22:43 -04 -04:00,
deleted_at:  nil,
user_id:  1,
post_type:  "Corporativas",
format:  0,
important:  true,
permission:  nil,
extract:  nil,
former_id:  nil,
migrated_id:  nil,
migrated_image_filename:  nil







<div class="row title_form">
<div class="col-sm-12">
  <div class="card">
    <div class="card-header">
      <div class="col-md-12">
        <div class="col-md-8">
          <% unless @post.main_image == nil %>
            <%= image_tag @post.main_image.large, class:'img-fluid'%>
          <% end %>
          <div>
            <%= get_post_status(@post) %>
          </div>
        </div>
        <div class="col-md-4">
          <%= raw @post.content %>
        </div>
    </div>
    <div class="card-body">
      <p class="card-text">
        </br>
      </p>
      <p class="card-text">
        <p><strong> Tags incluyentes: </strong></p>
        <%= @post.terms.inclusive_tags.map(&:name).join(', ') %>
        <p><strong> Tags excluyentes: </strong></p>
        <%= @post.terms.excluding_tags.map(&:name).join(', ') %>
      </p>
      <div align="center">
        <% if @post.galleries.present? %>
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target=".gallery-modal-lg" id='show_gallery'>Ver Galería</button>
        <% end %>
      </div>
      <div class="col-md-12">
        <div class="modal fade gallery-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
              <div class="row text-center" >
                <% @post.galleries.each do |gal| %>
                  <figure>
                    <figcaption class='text-center'><%= gal.name%></figcaption>
                    <% gal.attachments.each do |image| %>
                      <%= image_tag(image.attachment.attachment.variant(resize: '400x300>'), style: 'padding: 6px;') %>
                    <% end %>
                <% end %>
              </div>
            </div>
          </div>
        </div>
      </div>
      <br>
      <p class="card-text">
        <b>Última actualización:</b> <%= l(@post.updated_at, format: :long2) %>
      </p>
    </div>
  </div>
</div>
</div>

<div align="center">
<%= link_to t('.back', :default => t("helpers.links.back")), admin_posts_path, :class => 'btn btn-primary'  %>
<%= link_to t('.edit', :default => t("helpers.links.edit")), edit_admin_post_path(@post), :class => 'btn btn-primary' %>
<%= link_to 'Deshabilitar', admin_post_path(@post),:method => 'delete',:data => { :confirm => t('.confirm', :default => t("helpers.links.confirm", :default => '¿Estás seguro?')) },:class => 'btn btn-danger' %>
</div>
</div>
