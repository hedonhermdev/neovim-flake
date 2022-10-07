{ plugins, ... }:

{ vim }: if builtins.elem plugin plugins then true else false;
