local kernel = {}
kernel.language = "glsl"

kernel.category = "filter"
kernel.name = "glowing"

kernel.graph =
{
   nodes = {
      saturate = { effect="filter.saturate", input1="paint1" },
      blur = { effect="filter.zoomBlur", input1="saturate" },      
      exposure = { effect="filter.exposure", input1="blur" },    

   },
   output = "exposure",
}

return kernel
