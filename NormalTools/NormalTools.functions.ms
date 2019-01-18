struct NamespaceNormalTools
(
    SpherizeCenter = undefined,

    NormalTransferSource = undefined,

    fn Init = 
    (
        SpherizeCenter = undefined
        NormalTransferSource = undefined
    ),

    fn TransferNormal transferTarget transferSource editor = 
    (
        local start = timestamp()

        max modify mode

        local tri_tObj = snapshotasmesh transferSource
        local tObj = editable_mesh()
        tObj.mesh = tri_tObj

        local mpi = MeshProjIntersect()

        try
        (
            local s_NumNorm = editor.GetNumNormals()
            editor.SetSelection #{1..s_NumNorm}
            editor.Unify()
            editor.MakeExplicit()
            local s_NumVert = editor.GetNumVertices()

            ----get all transferTarget object vertex coordinates
            local refTransform = transferTarget.objecttransform
            start = timestamp()
            
            local vCoords = for i = 1 to s_NumVert collect (editor.GetVertex i) * refTransform
            local end = timestamp()
            format "took % seconds\n" ((end-start)/1000.0)

            --set transferSource
            select tObj
            
            ----set normal modifier on transferSource object
            local mtNormals = Edit_Normals ()
            mtNormals.displayLength = 0
            addmodifier tObj mtNormals

            local t_NumVert = mtNormals.GetNumVertices()
            local normalArray = #()
            normalArray[t_NumVert] = 0
            local closestVertArray = #()
            closestVertArray[s_NumVert] = 0

            --collect all normals of transferSource object in normalArray
            for i = 1 to t_NumVert do
            (
                local tnormalIDArray = #{}
                local t_Vert = #{i}
                mtNormals.ConvertVertexSelection &t_Vert &tnormalIDArray
                local tnormID = (tnormalIDArray as array)[1]
                n = mtNormals.Getnormal tnormID
                normalArray[i] = n
            )

            --for each vertex of transferTarget object, collect the closest point on transferSource object in closestVertArray
            mpi.SetNode tObj
            mpi.Build()

            local getVertPos = meshop.getVert
            for i =1 to s_NumVert do
            (
                local refPos = vCoords[i]
                local check = mpi.closestFace refPos doubleSided:true

                --if hit succeed
                if check == true then
                (
                    local closestVert = 0
                    local closestPoint = mpi.GetHitPos()
                    local closestFace = mpi.GetHitFace()

                    --zero based index
                    closestFace += 1

                    local d = 10000000.0 --max distance to look for
                    local vID = getFace tObj closestFace
                    local vv = #(vID.x,vID.y,vID.z)

                    for v in vv do
                    (
                        local curDist = distance (getVertPos tObj v) closestPoint
                        if curDist < d do
                        (
                            closestVert = v
                            d = curDist
                        )
                    )
                    closestVertArray[i] = closestVert
                )
                --if hit fails
                else
                (
                    closestVertArray[i] = 1
                    format "Warning : fail on transferTarget vertex %\n" i
                )
            )

            --set normals on transferTarget obj
            select transferTarget
            disableRefMsgs()
            for i =1 to s_NumVert do
            (
                local s_normalIDArray = #{}
                editor.ConvertVertexSelection #{i} s_normalIDArray
                local s_normID = (s_normalIDArray as array)[1]
                local closestVert = closestVertArray[i]
                local s_norm = normalArray[closestVert]
                editor.SetNormal s_normID s_norm
            )
            enableRefMsgs()

            --force UI refresh
            redrawViews()
        )
        catch
        (
            print (getCurrentException())
        )

        --clean scene
        delete tObj
        mpi.Free()

        max select

        end = timestamp()
        format "took % seconds\n" ((end-start)/1000.0)
    ),

    fn IsEditable o =
    (
        return (classof o == PolyMeshObject) or (classof o == Editable_Poly)
    ),

    fn MulNormalOffset o v editor world = 
    (
        if world then
        (
            in coordsys world
            (
                local matrix = inverse o.transform
                matrix.translation = [0, 0, 0]
                v = v * matrix
            )
        )

        max modify mode

        try
        (
            local sels = editor.GetSelection node:o

            if sels.count == 0 then sels = #{1..(editor.GetNumNormals())}

            for i in sels do
            (
                local normal = editor.GetNormal i node:o
                normal = [normal.x * v.x, normal.y * v.y, normal.z * v.z]
                editor.SetNormal i normal node:o
                editor.SetNormalExplicit i
            )
        )
        catch
        (
            print (getCurrentException())
        )

        max select
    ),

    fn RemakeNormals o editor =
    (
        max modify mode

        editor.RecomputeNormals()

        max select
    ),

    fn AddNormalOffset o v editor absolute world = 
    (
        if world then
        (
            in coordsys world
            (
                local matrix = inverse o.transform
                matrix.translation = [0, 0, 0]
                v = v * matrix
            )
        )

        max modify mode

        try
        (
            local sels = editor.GetSelection node:o

            if sels.isEmpty then sels = #{1..(editor.GetNumNormals())}

            print sels.count

            if absolute then
            (
                for i in sels do
                (
                    local normal = normalize(v)
                    editor.SetNormal i normal node:o
                    editor.SetNormalExplicit i
                )
            )
            else
            (
                for i in sels do
                (
                    local normal = editor.GetNormal i node:o
                    normal = normalize(normal + v)
                    editor.SetNormal i normal node:o
                    editor.SetNormalExplicit i
                )
            )
        )
        catch
        (
            print (getCurrentException())
        )

        max select
    ),
    
    fn NormalizeNormal o editor = 
    (
        max modify mode

        try
        (
            local sels = editor.GetSelection node:o

            if sels.isEmpty then sels = #{1..(editor.GetNumNormals())}
        
            for i in sels do
            (
                local normal = editor.GetNormal i node:o
                normal = normalize(normal)
                editor.SetNormal i normal node:o
                editor.SetNormalExplicit i
            )
        )
        catch
        (
            print (getCurrentException())
        )

        max select
    ),
    
    fn InverseNormal o editor = 
    (
        max modify mode

        try
        (
            local sels = editor.GetSelection node:o

            if sels.isEmpty then sels = #{1..(editor.GetNumNormals())}

            for i in sels do
            (
                local normal = editor.GetNormal i node:o
                normal = -normal
                editor.SetNormal i normal node:o
                editor.SetNormalExplicit i
            )
        )
        catch
        (
            print (getCurrentException())
        )

        max select
    ),

    fn ValidNormalModifier o = 
    (
        local editor = undefined
        
        for m in o.modifiers do
        (
            if classof m == Edit_Normals and m.name == "NormalTools.EDIT" then
            (
                editor = m
                return editor
            )
        )
        
        editor = EditNormals name:"NormalTools.EDIT"
        addmodifier o editor

        return editor
    ),

    fn GetVertexIDFromNormalID o id editor = 
    (
        for f = 1 to (getnumfaces o) do
        (
            for v = 1 to 4 do -- quad 4 / tri 3
            (
                if id == (editor.GetNormalID f v) then
                (
                    return editor.GetVertexID f v
                )
            )
        )

        print ("GetVertexIDFromNormalID failed " + (id as string))
        return id
    ),

    fn SpherizeNormal o editor ratio = 
    (
        if ratio == 0 then
            return()

        local center = [o.min.x + (o.max.x - o.min.x) * 0.5, o.min.y + (o.max.y - o.min.y) * 0.5, o.min.z + (o.max.z - o.min.z) * 0.5]

        if SpherizeCenter != undefined then
        (
            center = SpherizeCenter.pos
        )

        in coordsys world
        (
            local matrix = inverse o.transform
            center = center * matrix
        )

        local sels = editor.GetSelection node:o

        if sels.isEmpty then sels = #{1..(editor.GetNumNormals())}

        try
        (
            for i in sels do
            (
                local p = editor.GetVertex (GetVertexIDFromNormalID o i editor)
                local normal = editor.GetNormal i node:o
                local sphNormal = normalize(p - center)
                normal = (sphNormal - normal) * ratio + normal -- lerp between the spherized normal and the original normal
                editor.SetNormal i normal node:o
                editor.SetNormalExplicit i
            )
        )
        catch
        (
            print (getCurrentException())
        )
    ),
    
    fn CovertNormalToVertexColor o editor = 
    (
        local numNormals = editor.GetNumNormals()

        editor.SetSelection #{1..numNormals}

        local n = (polyop.getNumVerts o)
        
        print (o.name + " NORMAL: " + (numNormals as string))
            
        polyop.setMapSupport  o 0 true
        polyop.setNumMapVerts o 0 n keep:false

        local normals = #()
        For i = 1 to n do
        (
            local vtx = #{i}
            local nrm = #{}
            editor.ConvertVertexSelection &vtx &nrm
            append normals (nrm as array)
        )

        local smoothed_normals = #()

        for i = 1 to n do
        (
            local index = normals[i][1]
            local normal = editor.GetNormal index node:o

            normal = normalize(normal)

            polyop.setMapVert o 0 i (normal * 0.5 + 0.5)
        )
    )
)

global NormalTools = NamespaceNormalTools()