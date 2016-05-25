using UnityEngine;

public class DestroyByBoundary : MonoBehaviour
{
  void OnTriggerExit(Collider other)
  {
    Destroy(other.gameObject);
  }
}
