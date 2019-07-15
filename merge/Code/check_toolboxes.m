function toolboxes_in_use = check_toolboxes(fctname)
    [fList,pList]=matlab.codetools.requiredFilesAndProducts(fctname);
    if (size({pList.Name}',1)>1) %True, wenn mehr als nur MATLAB, d.H Toolboxes verwendet wird.
        toolboxes_in_use=true;
    else
        toolboxes_in_use=false;
    end
end