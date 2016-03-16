function render_qr_item (
    p_item                in apex_plugin.t_page_item,
    p_plugin              in apex_plugin.t_plugin,
    p_value               in varchar2,
    p_is_readonly         in boolean,
    p_is_printer_friendly in boolean )
    return apex_plugin.t_page_item_render_result
is
    l_size          apex_application_page_items.attribute_01%type := p_item.attribute_01;
    l_color         apex_application_page_items.attribute_01%type := p_item.attribute_02;
    l_background    apex_application_page_items.attribute_01%type := p_item.attribute_03;
    l_err_correction_level apex_application_page_items.attribute_01%type := p_item.attribute_04;
begin

  if apex_application.g_debug then
    apex_plugin_util.debug_page_item(
      p_plugin        => p_plugin,
      p_page_item     => p_item
    );
  end if;
   
  apex_javascript.add_library(
     p_name      => 'qrcode.min',
     p_directory => p_plugin.file_prefix,
     p_version   => NULL
  );

  sys.htp.p('<div id="QR-'||p_item.id||'" style="width:'||l_size||'px; height:'||l_size||'px;"></div>');

  apex_javascript.add_inline_code (
    p_code => 'function renderQR_'||p_item.name||'(value) 
{ $("#QR-'||p_item.id||'").html(" ");
  new QRCode(document.getElementById("QR-'||p_item.id||'"), {
  text:   value, 
  width:  "'||l_size||'" , 
  height: "'||l_size||'" ,
  colorDark:  "'||l_color||'" , 
  colorLight: "'||l_background||'" ,
  correctLevel : QRCode.CorrectLevel.'||l_err_correction_level||'
  } );
}',
    p_key  => 'renderQR_'||p_item.name
  );

  apex_javascript.add_onload_code (
    p_code => 'renderQR_'||p_item.name||'("'||p_value||'");', 
    p_key  => 'renderQR_'||p_item.name
  );
  
  return null;
end;