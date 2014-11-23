function val = force_sparsity(vec)
    val = norm(vec)^2;
    sparsity = 0;
    s = size(vec);
    if s(1) == 1
        s = s(2);
    else
        s = s(1);
    end
    lambda = 25 * sqrt(s);
    for i = 1:s
        sparsity = sparsity + log(1 + vec(i)^2);
    end
    val= val + lambda * sparsity;
end