using UnityEngine;
using System.Collections;

public class Patrol : MonoBehaviour {

    public GameObject m_wayPointA;
    public GameObject m_wayPointB;
    public bool m_isMoveToA;
    public float m_moveSpeed;
    public float m_rotationSpeed;
    public float m_rotationFactor;

	// Use this for initialization
	void Start () {
        m_isMoveToA = true;
        m_moveSpeed = 3.0f;
        m_rotationSpeed = 3f;
        m_rotationFactor = 0.0f;
	}
	
	// Update is called once per frame
	void Update () {

        MoveToWayPoint();
	}

    void MoveToWayPoint()
    {
        if (m_isMoveToA == true)
        {
            Quaternion targetRot = Quaternion.LookRotation(m_wayPointA.transform.position - transform.position);
            m_rotationFactor += Time.deltaTime / m_rotationSpeed;
            m_rotationFactor = Mathf.Min(m_rotationFactor, 1.0f);
            transform.rotation = Quaternion.Slerp(transform.rotation, targetRot, m_rotationFactor);
            transform.Translate(Vector3.forward * Time.deltaTime * m_moveSpeed);

            if (Vector3.Distance(m_wayPointA.transform.position, transform.position) < 0.5f)
            {
                m_isMoveToA = false;
                m_rotationFactor = 0.0f;
            }
        }
        else
        {
            Quaternion targetRot = Quaternion.LookRotation(m_wayPointB.transform.position - transform.position);
            m_rotationFactor += Time.deltaTime / m_rotationSpeed;
            m_rotationFactor = Mathf.Min(m_rotationFactor, 1.0f);
            transform.rotation = Quaternion.Slerp(transform.rotation, targetRot, m_rotationFactor);
            transform.Translate(Vector3.forward * Time.deltaTime * m_moveSpeed);

            if (Vector3.Distance(m_wayPointB.transform.position, transform.position) < 0.5f)
            {
                m_isMoveToA = true;
                m_rotationFactor = 0.0f;
            }
        }
    }
}
