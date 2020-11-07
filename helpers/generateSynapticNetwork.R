def generateSynapticNetwork(W, showplot=default_args['showplot'], weight_loc = 1.0, weight_scale = .2):
  """
    Generate synaptic matrix over structural matrix with randomized gaussian weighs with
    mean = 1.0 and standard deviation of 0.2 (so all weights are positive)
    
    Parameters:
        W = structural connectivity matrix
        showplot = if set to True, will automatically display the structural matrix using matplotlib.pyplot

    Returns:
        Synaptic matrix with Gaussian weights on top of structural matrix
    """
# Find non-zero connections
G = np.zeros((W.shape))
totalnodes = G.shape[0]
connect_ind = np.where(W!=0)
nconnects = len(connect_ind[0])
weights = np.random.normal(loc=weight_loc,scale=weight_scale, size=(nconnects,))
G[connect_ind] = weights

# Find num connections per node
nodeDeg = np.sum(W,axis=1)

# Synaptic scaling according to number of incoming connections
np.fill_diagonal(G,0)
for col in range(G.shape[1]):
  G[:,col] = np.divide(G[:,col],np.sqrt(nodeDeg))
#G = G/np.sqrt(totalnodes)

if showplot:
  plt.figure()
plt.imshow(G, origin='lower')#, vmin=0, vmax=20)
plt.colorbar()
plt.title('Synaptic Weight Matrix -- Coupling Matrix', y=1.08)
plt.xlabel('Regions')
plt.ylabel('Regions')
plt.tight_layout()

return G